#!/bin/bash
set -euxo pipefail

SCRIPT="$0"
echo "# START SCRIPT: $SCRIPT"

# ./openapi-generator-check.sh || exit 1

# remote yaml on github branch "oauth"
ags="generate 
-t ../modules/csharp-netcore 
-i https://raw.githubusercontent.com/XeroAPI/Xero-OpenAPI/oauth2/accounting-yaml/Xero_accounting_2.0.0_swagger.yaml 
-g csharp-netcore
-o ../output/csharp-netcore/accounting
-c ./dotnet-oauth2-accounting.json 
-D debugModels=false
-D hideGenerationTimestamp=true
$@"
echo "Removing files and folders under output/output/csharp-netcore"
rm -rf ../output/csharp-netcore/accounting
openapi-generator $ags  
# hacky way of fixing some things without editing the templating engine
find ../output/csharp-netcore/accounting/src/Xero.NetStandard.OAuth2/project.json -type f -exec rm -rf {} \;
find ../output/csharp-netcore/accounting/src/Xero.NetStandard.OAuth2/Xero.NetStandard.OAuth2.csproj -type f -exec sed -i '' -e "/<TargetFrameworkIdentifier>.NETStandard<\/TargetFrameworkIdentifier>/d" {} +
find ../output/csharp-netcore/accounting/src/Xero.NetStandard.OAuth2/Xero.NetStandard.OAuth2.csproj -type f -exec sed -i '' -e "s/<TargetFrameworkVersion>v2.0<\/TargetFrameworkVersion>/<TargetFramework>netstandard2.0<\/TargetFramework>/g" {} +
find ../output/csharp-netcore/accounting/src/Xero.NetStandard.OAuth2/model/ -type f -exec sed -i '' -e "s/string? /string /g" {} +
find ../output/csharp-netcore/accounting/src/Xero.NetStandard.OAuth2/model/ -type f -exec sed -i '' -e "s/DateTime?? /DateTime? /g" {} +
find ../output/csharp-netcore/accounting/src/Xero.NetStandard.OAuth2/model/ -type f -exec sed -i '' -e "s/List<string>? /List<string> /g" {} +