# Faz login no GitHub CLI com um token, sem deixar o token em arquivo nem no histórico do terminal.
# Uso (PowerShell):  .\deploy\github-login.ps1
$seguro = Read-Host "Cole o token do GitHub (nao aparece na tela)" -AsSecureString
$ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($seguro)
try {
    [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr) | gh auth login --hostname github.com --git-protocol https --with-token
} finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
}
gh auth setup-git   # faz o git push usar o login do gh
gh auth status
