@echo off
set openssl=%ProgramFiles%\OpenSSL-Win64\bin\openssl.exe
IF NOT EXIST "%openssl%" (
    echo OpenSSL is not installed
	pause
	exit
)

echo           ----------------------------------------------
echo                           SSL Convert 1.0
echo              Put your .pfx file in the same directory
echo           ----------------------------------------------
echo.
echo.
echo.
echo.

for %%G in (*.pfx) do (
	call :extractssl "%%G"
)
pause
GOTO :eof

:extractssl
	set pfx=%1
	set key=%pfx:pfx=key% 
	set crt=%pfx:pfx=crt%
	echo --------- %pfx% --------------
	set /p password=Import Password ? 
	"%openssl%" pkcs12 -in %pfx% -clcerts -nokeys -out %crt% -passin pass:%password%
	echo Certificat: OK
	
	"%openssl%" pkcs12 -in %pfx% -nocerts -out %key% -passin pass:%password% -passout pass:1234
	"%openssl%" rsa -in %key% -out %key% -passin pass:1234 > nul 2>&1
	echo Private Key: OK
	echo.
	echo.