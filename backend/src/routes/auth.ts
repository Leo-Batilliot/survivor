import { Elysia, t } from 'elysia';
import { db } from '../db';
import { authPlugin } from '../auth/plugin';

export const authRoutes = new Elysia({ prefix: '/api/v1/auth' })
    .use(authPlugin)

    // Inscription partenaire — compte créé en PENDING, validé manuellement par l'admin
    .post('/partenaire/register', async ({ body, set }) => {
        const existing = await db.partenaire.findUnique({ where: { adresseMail: body.email } });
        if (existing) {
            set.status = 409;
            return { error: 'EMAIL_ALREADY_USED' };
        }

        const motDePasse = await Bun.password.hash(body.password);

        const partenaire = await db.partenaire.create({
            data: {
                nom: body.nom,
                adresseMail: body.email,
                motDePasse,
                adressePostal: body.adresse,
                numeroSiren: body.siren,
                objetSocial: body.objetSocial,
                statu: 'PENDING'
            }
        });

        return { id: partenaire.id, statut: partenaire.statu };
    }, {
        body: t.Object({
            nom: t.String(),
            email: t.String({ format: 'email' }),
            password: t.String({ minLength: 8 }),
            adresse: t.String(),
            siren: t.String(),
            objetSocial: t.String()
        })
    })

    .post('/salarie/login', async ({ body, jwt, set }) => {
        const salarie = await db.salarie.findUnique({ where: { adresseMail: body.email } });
        if (!salarie || !(await Bun.password.verify(body.password, salarie.motDePasse))) {
            set.status = 401;
            return { error: 'INVALID_CREDENTIALS' };
        }
        return { token: await jwt.sign({ sub: salarie.id, role: 'salarie' }) };
    }, { body: t.Object({ email: t.String({ format: 'email' }), password: t.String() }) })

    .post('/partenaire/login', async ({ body, jwt, set }) => {
        const partenaire = await db.partenaire.findUnique({ where: { adresseMail: body.email } });
        if (!partenaire || !(await Bun.password.verify(body.password, partenaire.motDePasse))) {
            set.status = 401;
            return { error: 'INVALID_CREDENTIALS' };
        }
        if (partenaire.statu !== 'APPROVED') {
            set.status = 403;
            return { error: 'PARTNER_NOT_APPROVED', message: 'Compte en attente de validation par le Ministère' };
        }
        return { token: await jwt.sign({ sub: partenaire.id, role: 'partenaire' }) };
    }, { body: t.Object({ email: t.String({ format: 'email' }), password: t.String() }) })

    .post('/admin/login', async ({ body, jwt, set }) => {
        const admin = await db.administration.findUnique({ where: { adresseMail: body.email } });
        if (!admin || !(await Bun.password.verify(body.password, admin.motDePasse))) {
            set.status = 401;
            return { error: 'INVALID_CREDENTIALS' };
        }
        return { token: await jwt.sign({ sub: admin.id, role: 'admin' }) };
    }, { body: t.Object({ email: t.String({ format: 'email' }), password: t.String() }) });