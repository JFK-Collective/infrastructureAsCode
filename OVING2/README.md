# Infrastructure as Code – Oblig 2

Denne besvarelsen demonstrerer bruk av moderne Infrastructure as Code (IaC)-prinsipper ved hjelp av Terraform, GitHub Actions og Microsoft Azure.  
Løsningen viser en komplett pipeline fra lokal utvikling til automatisk og versjonert utrulling gjennom GitHub Actions.

## Mål

- All infrastruktur skal være versjonert, sporbar og kunne recertifiseres på kort varsel.
- Samme Terraform-kode skal brukes i alle miljøer (build once, deploy many).
- Miljøene skal ha forskjellig konfigurasjon, men identisk struktur.
- Teamet skal kunne jobbe parallelt uten merge-konflikter (trunk-based development).

## Teknologi og oppsett

- Terraform brukes for å definere infrastruktur (Resource Group og Storage Account).
- Azure Key Vault lagrer tfvars-verdier Base64-kodet.
- GitHub Actions brukes til CI/CD og versjonering.
- OIDC brukes for sikker innlogging til Azure uten statiske secrets.
- Trunk-based development brukes for samarbeid og raske integrasjoner.

## Arbeidsflyt

### 1. Lokal utvikling

Utvikling starter lokalt. Terraform-koden skrives på egen maskin.  
Når endringene er klare, opprettes en feature branch, og koden pushes til GitHub.  
Deretter opprettes en Pull Request (PR) mot main.

### 2. Continuous Integration (CI)

Fil: `.github/workflows/terraform-ci.yml`

Når en Pull Request opprettes mot main, starter CI-pipelinen automatisk.

1. Terraform fmt – sjekker at koden er korrekt formatert.
2. Terraform validate – validerer syntaks og provider-konfigurasjon.
3. Terraform plan – kjøres for dev, test og prod for å sikre at koden fungerer i alle miljøer.
4. Resultatet postes som kommentar på Pull Requesten.

Dersom noe feiler, rettes koden lokalt og pushes på nytt.  
Når alt er validert og godkjent, kan pull requesten merges til main.

### 3. Build Once – Release

Fil: `.github/workflows/terraform-release.yml`

I stedet for å deploye direkte etter merge, deployeres infrastrukturen når en GitHub Release opprettes.  
Dette gir tydelig versjonering og gjør infrastrukturen enkel å reprodusere og recertifisere.

#### Prosess

1. Opprett en ny versjon:

git tag -a v1.2.0 -m "New infrastructure release"
git push origin v1.2.0

2. Når taggen pushes, bygges et artifact automatisk med github workflow:

terraform-v1.2.0.tar.gz

3. Artifactet lastes opp som release asset i GitHub Releases.

Dette artifactet representerer den eksakte koden som brukes i alle miljøer.  
Dermed bygges infrastrukturen én gang, og den samme koden brukes overalt.

### 4. Continuous Deployment (CD)

Fil: `.github/workflows/TerraformCD.yml`

CD-workflowen starter automatisk når en ny release publiseres.  
Den laster ned artifactet og deployer det sekvensielt til dev, test og prod.

#### Steg

1. Dev

- Henter dev-tfvars fra Key Vault.
- Kjører terraform init og terraform apply.

2. Test

- Starter etter dev.
- Bruker test-tfvars fra Key Vault.

3. Prod

- Starter etter at test.
- Henter `prod-tfvars` fra Key Vault.
- **Krever manuell godkjenning før den kjører**, via GitHub Environments.  
  En reviewer må godkjenne deployen i GitHub før produksjonsmiljøet oppdateres.
- Etter godkjenning kjører workflowen `terraform init` og `terraform apply`  
  med samme artifact som i dev og test.

## Prinsipper i bruk

Versjonering - Hver release har unik tag (v1.2.0) og eget artifact

Sporbarhet - All kode og infrastruktur kobles til commit og release

Recertifisering - Tidligere release kan lastes ned og deployes på nytt

Miljøparitet - Samme kode, forskjellig konfigurasjon via tfvars

Build once, deploy many - Artifact bygges én gang og brukes til alle miljøer

Trunk-based development - Korte feature branches, raske merges og automatisk validering
