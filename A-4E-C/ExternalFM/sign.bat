signtool.exe sign /tr "http://timestamp.digicert.com" /td sha256 /fd sha256 /f "C:\Users\joshn\Documents\Certificates\A-4E-C\A-4E-C_EFM_dev.pfx" /as /p 123 "$(TargetPath)"
exit(0)