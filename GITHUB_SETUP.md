# Instrukcja połączenia z GitHub i wypchnięcia projektu

## Krok 1: Konfiguracja Git (jeśli jeszcze nie skonfigurowane)

```bash
git config --global user.name "Twoje Imię"
git config --global user.email "twoj@email.com"
```

## Krok 2: Inicjalizacja repozytorium lokalnego

```bash
cd C:\Users\Patryk\Desktop\budapp
git init
```

## Krok 3: Dodanie plików do staging

```bash
git add .
```

## Krok 4: Utworzenie pierwszego commita

```bash
git commit -m "Initial commit: Flutter BudApp project"
```

## Krok 5: Utworzenie repozytorium na GitHub

1. Zaloguj się na https://github.com
2. Kliknij przycisk "+" w prawym górnym rogu
3. Wybierz "New repository"
4. Wpisz nazwę repozytorium (np. "budapp")
5. **NIE zaznaczaj** "Initialize this repository with a README" (bo już masz projekt)
6. Kliknij "Create repository"

## Krok 6: Połączenie lokalnego repozytorium z GitHub

Po utworzeniu repozytorium na GitHub, skopiuj URL (np. `https://github.com/twoja-nazwa/budapp.git` lub `git@github.com:twoja-nazwa/budapp.git`)

```bash
git remote add origin https://github.com/TWOJA-NAZWA-USERNAME/budapp.git
```

**UWAGA:** Zamień `TWOJA-NAZWA-USERNAME` na swoją nazwę użytkownika GitHub!

## Krok 7: Wypchnięcie kodu na GitHub

```bash
git branch -M main
git push -u origin main
```

## Jeśli używasz SSH zamiast HTTPS:

Jeśli wolisz używać SSH (wymaga skonfigurowania klucza SSH):

```bash
git remote add origin git@github.com:TWOJA-NAZWA-USERNAME/budapp.git
git branch -M main
git push -u origin main
```

## Sprawdzenie statusu

```bash
git status
git remote -v
```

## Ważne uwagi:

1. **Plik .env jest już w .gitignore** - klucze API nie trafią do repozytorium ✅
2. **firebase_options.dart** zawiera publiczne klucze Firebase - są bezpieczne do udostępnienia
3. Jeśli GitHub poprosi o autoryzację, użyj Personal Access Token zamiast hasła

## Jeśli potrzebujesz Personal Access Token:

1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token (classic)
3. Wybierz scope: `repo` (pełny dostęp do repozytoriów)
4. Skopiuj token i użyj go jako hasła przy `git push`

