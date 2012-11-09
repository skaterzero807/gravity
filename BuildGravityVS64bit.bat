Rem ember to run this from the 64 BIT Visual Studio Command Prompt.  
mkdir bin64
mkdir lib64
mkdir include
mkdir include\protobuf

Rem Build ThirdParty
cd ThirdParty

mkdir bin64
mkdir lib64

cd protobuf-2.4.1\vsprojects
msbuild libprotobuf.vcxproj /p:Configuration=Release /p:Platform=x64 || goto build_fail
msbuild protoc.vcxproj /p:Configuration=Release /p:Platform="x64" || goto build_fail
copy x64\Release\libprotobuf.lib ..\..\lib64
copy x64\Release\protoc.exe ..\..\bin64

cd ..\..\zeromq-3.2.1\builds\msvc11
msbuild msvc11.sln /p:Configuration=Release /p:Platform="x64" || goto build_fail
copy ..\..\lib\x64\libzmq.lib ..\..\..\lib64\libzmq.lib
copy ..\..\bin\x64\libzmq.dll ..\..\..\bin64\libzmq.dll

cd ..\..\..\iniparser\build
msbuild iniparser.sln /p:Configuration=Release /p:Platform="x64" || goto build_fail
Rem lib File from this project is built directly into the lib directory

cd ..\..\..
copy ThirdParty\pthreads\lib\x64\pthreadVC2.lib ThirdParty\lib64
copy ThirdParty\pthreads\bin\x64\pthreadVC2.dll ThirdParty\bin64

Rem Build gravity
cd build\msvs\gravity
msbuild gravity.sln /p:Configuration=Release /p:Platform="x64" || goto build_fail

cd ..\..\..\build\msvs\components\ServiceDirectory
msbuild ServiceDirectory.sln /p:Configuration=Release /p:Platform="x64" || goto build_fail
copy x64\Release\ServiceDirectory.exe ..\..\..\..\bin64
copy ..\..\..\..\src\components\cpp\ServiceDirectory\ServiceDirectory.ini ..\..\..\..\bin64
cd ..\..\..\..\

Rem Copy files to output directory.  
copy Thirdparty\bin64\* bin64
copy Thirdparty\lib64\libprotobuf.lib lib64

copy src\api\cpp\*.h include
copy src\api\cpp\protobuf\GravityDataProductPB.pb.h include\protobuf

xcopy /s /q /y ThirdParty\protobuf-2.4.1\src\*.h include
cd include\google
cd ..\..

goto end

:build_fail
@echo Build Failed

:end