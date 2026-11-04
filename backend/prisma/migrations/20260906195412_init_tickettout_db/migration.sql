/*
  Warnings:

  - You are about to drop the column `adresse mail` on the `administration` table. All the data in the column will be lost.
  - You are about to drop the column `historique abondement` on the `administration` table. All the data in the column will be lost.
  - You are about to drop the column `mot de passe` on the `administration` table. All the data in the column will be lost.
  - You are about to drop the column `admin id` on the `decision partenaire` table. All the data in the column will be lost.
  - You are about to drop the column `partenaire id` on the `decision partenaire` table. All the data in the column will be lost.
  - You are about to drop the column `adresse mail` on the `partenaires (public)` table. All the data in the column will be lost.
  - You are about to drop the column `adresse postal` on the `partenaires (public)` table. All the data in the column will be lost.
  - You are about to drop the column `mot de passe` on the `partenaires (public)` table. All the data in the column will be lost.
  - You are about to drop the column `numero de SIREN` on the `partenaires (public)` table. All the data in the column will be lost.
  - You are about to drop the column `objet social` on the `partenaires (public)` table. All the data in the column will be lost.
  - You are about to drop the column `clé d'idempotence` on the `transaction` table. All the data in the column will be lost.
  - You are about to drop the column `partenaire id` on the `transaction` table. All the data in the column will be lost.
  - You are about to drop the column `salarié id` on the `transaction` table. All the data in the column will be lost.
  - You are about to drop the `salarié` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[adresse_mail]` on the table `administration` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[adresse_mail]` on the table `partenaires (public)` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[cle_idempotence]` on the table `transaction` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `adresse_mail` to the `administration` table without a default value. This is not possible if the table is not empty.
  - Added the required column `historique_abondement` to the `administration` table without a default value. This is not possible if the table is not empty.
  - Added the required column `mot_de_passe` to the `administration` table without a default value. This is not possible if the table is not empty.
  - Added the required column `admin_id` to the `decision partenaire` table without a default value. This is not possible if the table is not empty.
  - Added the required column `partenaire_id` to the `decision partenaire` table without a default value. This is not possible if the table is not empty.
  - Added the required column `adresse_mail` to the `partenaires (public)` table without a default value. This is not possible if the table is not empty.
  - Added the required column `adresse_postal` to the `partenaires (public)` table without a default value. This is not possible if the table is not empty.
  - Added the required column `mot_de_passe` to the `partenaires (public)` table without a default value. This is not possible if the table is not empty.
  - Added the required column `numero_de_SIREN` to the `partenaires (public)` table without a default value. This is not possible if the table is not empty.
  - Added the required column `objet_social` to the `partenaires (public)` table without a default value. This is not possible if the table is not empty.
  - Added the required column `cle_idempotence` to the `transaction` table without a default value. This is not possible if the table is not empty.
  - Added the required column `partenaire_id` to the `transaction` table without a default value. This is not possible if the table is not empty.
  - Added the required column `salarie_id` to the `transaction` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "decision partenaire" DROP CONSTRAINT "decision partenaire_partenaire id_fkey";

-- DropForeignKey
ALTER TABLE "transaction" DROP CONSTRAINT "transaction_partenaire id_fkey";

-- DropForeignKey
ALTER TABLE "transaction" DROP CONSTRAINT "transaction_salarié id_fkey";

-- DropIndex
DROP INDEX "administration_adresse mail_key";

-- DropIndex
DROP INDEX "partenaires (public)_adresse mail_key";

-- DropIndex
DROP INDEX "transaction_clé d'idempotence_key";

-- AlterTable
ALTER TABLE "administration" DROP COLUMN "adresse mail",
DROP COLUMN "historique abondement",
DROP COLUMN "mot de passe",
ADD COLUMN     "adresse_mail" TEXT NOT NULL,
ADD COLUMN     "historique_abondement" TEXT NOT NULL,
ADD COLUMN     "mot_de_passe" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "decision partenaire" DROP COLUMN "admin id",
DROP COLUMN "partenaire id",
ADD COLUMN     "admin_id" TEXT NOT NULL,
ADD COLUMN     "partenaire_id" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "partenaires (public)" DROP COLUMN "adresse mail",
DROP COLUMN "adresse postal",
DROP COLUMN "mot de passe",
DROP COLUMN "numero de SIREN",
DROP COLUMN "objet social",
ADD COLUMN     "adresse_mail" TEXT NOT NULL,
ADD COLUMN     "adresse_postal" TEXT NOT NULL,
ADD COLUMN     "mot_de_passe" TEXT NOT NULL,
ADD COLUMN     "numero_de_SIREN" TEXT NOT NULL,
ADD COLUMN     "objet_social" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "transaction" DROP COLUMN "clé d'idempotence",
DROP COLUMN "partenaire id",
DROP COLUMN "salarié id",
ADD COLUMN     "cle_idempotence" TEXT NOT NULL,
ADD COLUMN     "partenaire_id" TEXT NOT NULL,
ADD COLUMN     "salarie_id" TEXT NOT NULL;

-- DropTable
DROP TABLE "salarié";

-- CreateTable
CREATE TABLE "salarie" (
    "id" TEXT NOT NULL,
    "prenom" TEXT NOT NULL,
    "adresse_mail" TEXT NOT NULL,
    "mot_de_passe" TEXT NOT NULL,
    "solde" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "salarie_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "salarie_adresse_mail_key" ON "salarie"("adresse_mail");

-- CreateIndex
CREATE UNIQUE INDEX "administration_adresse_mail_key" ON "administration"("adresse_mail");

-- CreateIndex
CREATE UNIQUE INDEX "partenaires (public)_adresse_mail_key" ON "partenaires (public)"("adresse_mail");

-- CreateIndex
CREATE UNIQUE INDEX "transaction_cle_idempotence_key" ON "transaction"("cle_idempotence");

-- AddForeignKey
ALTER TABLE "transaction" ADD CONSTRAINT "transaction_partenaire_id_fkey" FOREIGN KEY ("partenaire_id") REFERENCES "partenaires (public)"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transaction" ADD CONSTRAINT "transaction_salarie_id_fkey" FOREIGN KEY ("salarie_id") REFERENCES "salarie"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "decision partenaire" ADD CONSTRAINT "decision partenaire_partenaire_id_fkey" FOREIGN KEY ("partenaire_id") REFERENCES "partenaires (public)"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
