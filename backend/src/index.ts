import { Elysia } from 'elysia';
import { db } from './db';
import { authPlugin } from './auth/plugin';
import { authRoutes } from './routes/auth';

const app = new Elysia()
    .use(authPlugin)
    .use(authRoutes)
    .get('/health', () => ({ status: 'ok', version: '0.1.0' }))
    .get('/api/v1/employees/:id/balance', async ({ params, user, set }) => {
        if (user.role === 'salarie' && user.id !== params.id) {
            set.status = 403;
            return { error: 'FORBIDDEN', message: 'Vous ne pouvez consulter que votre propre solde' };
        }

        const salarie = await db.salarie.findUnique({
            where: { id: params.id },
            select: { id: true, solde: true }
        });

        if (!salarie) {
            set.status = 404;
            return { error: 'EMPLOYEE_NOT_FOUND', message: `Aucun salarié avec l'id ${params.id}` };
        }

        return { employeeId: salarie.id, balance: salarie.solde };
    }, { auth: true })
    .listen(3000);

console.log(`🦊 Backend Ticket Tout démarré sur http://localhost:${app.server?.port}`);