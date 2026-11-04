import { Elysia } from 'elysia';
import { jwt } from '@elysiajs/jwt';

export const authPlugin = new Elysia({ name: 'auth' })
    .use(
        jwt({
            name: 'jwt',
            secret: process.env.JWT_SECRET!,
            exp: '2h'
        })
    )
    .macro({
        auth: {
            async resolve({ jwt, headers, status }) {
                const authHeader = headers.authorization;
                if (!authHeader?.startsWith('Bearer ')) {
                    return status(401, { error: 'UNAUTHORIZED', message: 'Token manquant' });
                }

                const payload = await jwt.verify(authHeader.slice(7));
                if (!payload) {
                    return status(401, { error: 'INVALID_TOKEN', message: 'Token invalide ou expiré' });
                }

                return {
                    user: {
                        id: payload.sub as string,
                        role: payload.role as 'salarie' | 'partenaire' | 'admin'
                    }
                };
            }
        }
    });