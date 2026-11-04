import fs from 'fs';

// --- CONFIGURATION DÉTERMINISTE ---
let seedValue = 123456789;
function pseudoRandom() {
    seedValue = (seedValue * 9301 + 49297) % 233280;
    return seedValue / 233280;
}

function getRandomInt(min, max) {
    return Math.floor(pseudoRandom() * (max - min + 1)) + min;
}

const ANCHOR_DATE = new Date('2026-06-01T08:00:00.000Z');
const FIRST_NAMES = ['Jean', 'Sophie', 'Lucas', 'Emma', 'Alexandre', 'Camille', 'Thomas', 'Léa', 'Antoine', 'Chloé'];
const LAST_NAMES = ['Martin', 'Bernard', 'Dubois', 'Thomas', 'Robert', 'Richard', 'Petit', 'Durand', 'Leroy', 'Moreau'];
const OBJETS_SOCIAUX = ['Restauration', 'Commerce', 'Divertissement', 'Services'];
const REGIONS = ['75001 Paris', '59000 Lille', '69001 Lyon', '13001 Marseille'];

// --- 1. TABLES DB : SALARIÉS (50) ---
const salaries = Array.from({ length: 50 }, (_, i) => {
    const id = `emp_${(i + 1).toString().padStart(3, '0')}`;
    const prenom = FIRST_NAMES[i % FIRST_NAMES.length];
    const nom = LAST_NAMES[(i * 3) % LAST_NAMES.length];
    return {
        id,
        prenom: `${prenom} ${nom}`,
        adresse_mail: `${prenom.toLowerCase()}.${nom.toLowerCase()}@email.fr`,
        mot_de_passe: '$2b$10$e8T...hashed_password',
        solde: 0 // Solde dynamique recalculé au fil des opérations
    };
});

// --- 2. TABLES DB : PARTENAIRES (12) ---
const partenaires = Array.from({ length: 12 }, (_, i) => {
    const id = `part_${(i + 1).toString().padStart(3, '0')}`;
    return {
        id,
        nom: `Espace Partenaire ${i + 1}`,
        adresse_mail: `contact@partenaire${i + 1}.fr`,
        mot_de_passe: '$2b$10$e8T...hashed_password',
        adresse_postal: REGIONS[i % REGIONS.length],
        numero_de_siren: `${100000000 + i * 11111111}`,
        objet_social: OBJETS_SOCIAUX[i % OBJETS_SOCIAUX.length],
        statu: 'VALIDE'
    };
});

// --- 3. TABLES DB : TRANSACTIONS (200) ---
const transactions = [];
let totalTx = 0;
let totalRefused = 0;

const zeroBalanceEmpIds = new Set(['emp_001', 'emp_002', 'emp_003']);
const lowBalanceEmpIds = new Set(['emp_004', 'emp_005']);

// Simulation chronologique sur 90 jours
for (let day = 0; day < 90; day++) {
    const currentDate = new Date(ANCHOR_DATE.getTime() + day * 24 * 60 * 60 * 1000);

    // Abondement mensuel (tous les 30 jours)
    if (day % 30 === 0) {
        salaries.forEach(emp => {
            emp.solde += 15000; // 150,00 €
        });
    }

    salaries.forEach(emp => {
        if (totalTx >= 200) return;

        if (pseudoRandom() > 0.85 || zeroBalanceEmpIds.has(emp.id) || lowBalanceEmpIds.has(emp.id)) {
            let amount = getRandomInt(800, 2500);

            if (day > 80) {
                if (zeroBalanceEmpIds.has(emp.id) && emp.solde > 0) {
                    amount = emp.solde;
                } else if (lowBalanceEmpIds.has(emp.id) && emp.solde > 500) {
                    amount = emp.solde - 300;
                }
            }

            let status = 'APPROVED';

            if (emp.solde < amount) {
                status = 'REFUSED';
                totalRefused++;
            } else {
                emp.solde -= amount;
            }

            if (status === 'REFUSED' && totalRefused > 5) return;

            totalTx++;
            const part = partenaires[getRandomInt(0, partenaires.length - 1)];
            const txDate = new Date(currentDate.getTime() + getRandomInt(3600, 43200) * 1000);

            transactions.push({
                id: `tx_${totalTx.toString().padStart(3, '0')}`,
                partenaire_id: part.id,
                salarie_id: emp.id,
                montant: amount,
                heure: txDate.toISOString(),
                cle_didempotence: `idem_${totalTx}_${txDate.getTime()}`,
                status: status
            });
        }
    });
}

// --- 4. EXPORT CSV CONFORME AUX EXIGENCES CLIENT ---
// Colonnes strictes requises par le client : id;date_iso8601;employee_id;partner_id;amount_cents;status
const csvHeader = 'id;date_iso8601;employee_id;partner_id;amount_cents;status\n';
const csvRows = transactions.map(t => 
    `${t.id};${t.heure};${t.salarie_id};${t.partenaire_id};${t.montant};${t.status}`
).join('\n');

fs.writeFileSync('transactions.csv', csvHeader + csvRows, 'utf8');

console.log('--- SEED CONFORME SCHÉMA DB GÉNÉRÉ ---');
console.log(`- Salariés créés : ${salaries.length}`);
console.log(`- Partenaires créés : ${partenaires.length}`);
console.log(`- Transactions créées : ${transactions.length} (dont ${totalRefused} refusées)`);
console.log(`- Fichier "transactions.csv" généré avec succès.`);