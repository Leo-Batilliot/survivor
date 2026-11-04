-- CreateTable
CREATE TABLE "salarié" (
    "id" TEXT NOT NULL,
    "prenom" TEXT NOT NULL,
    "adresse mail" TEXT NOT NULL,
    "mot de passe" TEXT NOT NULL,
    "solde" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "salarié_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "partenaires (public)" (
    "id" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "adresse mail" TEXT NOT NULL,
    "mot de passe" TEXT NOT NULL,
    "adresse postal" TEXT NOT NULL,
    "numero de SIREN" TEXT NOT NULL,
    "objet social" TEXT NOT NULL,
    "statu" TEXT NOT NULL DEFAULT 'PENDING',

    CONSTRAINT "partenaires (public)_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transaction" (
    "id" TEXT NOT NULL,
    "partenaire id" TEXT NOT NULL,
    "salarié id" TEXT NOT NULL,
    "montant" INTEGER NOT NULL,
    "heure" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "clé d'idempotence" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'APPROVED',

    CONSTRAINT "transaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "decision partenaire" (
    "id" TEXT NOT NULL,
    "partenaire id" TEXT NOT NULL,
    "admin id" TEXT NOT NULL,
    "decision" TEXT NOT NULL,
    "motif" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "decision partenaire_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "administration" (
    "id" TEXT NOT NULL,
    "adresse mail" TEXT NOT NULL,
    "mot de passe" TEXT NOT NULL,
    "historique abondement" TEXT NOT NULL,

    CONSTRAINT "administration_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "salarié_adresse mail_key" ON "salarié"("adresse mail");

-- CreateIndex
CREATE UNIQUE INDEX "partenaires (public)_adresse mail_key" ON "partenaires (public)"("adresse mail");

-- CreateIndex
CREATE UNIQUE INDEX "transaction_clé d'idempotence_key" ON "transaction"("clé d'idempotence");

-- CreateIndex
CREATE UNIQUE INDEX "administration_adresse mail_key" ON "administration"("adresse mail");

-- AddForeignKey
ALTER TABLE "transaction" ADD CONSTRAINT "transaction_partenaire id_fkey" FOREIGN KEY ("partenaire id") REFERENCES "partenaires (public)"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transaction" ADD CONSTRAINT "transaction_salarié id_fkey" FOREIGN KEY ("salarié id") REFERENCES "salarié"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "decision partenaire" ADD CONSTRAINT "decision partenaire_partenaire id_fkey" FOREIGN KEY ("partenaire id") REFERENCES "partenaires (public)"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
