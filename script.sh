while getopts c:p: flag
do
    case "${flag}" in
        c) company=${OPTARG};;
        p) project=${OPTARG};;
    esac
done
echo "Company: ^$company^";
echo "Project: ^$project^";

if [[ -z "$company" ]]; then
    echo 'Company is required parameters'
    exit 1
fi

if [[ -z "$project" ]]; then
    echo 'Project is required parameters'
    exit 1
fi

# Create .Net Core Web API application
dotnet new sln --name $company.$project
dotnet new webapi -au IndividualB2C -f net5.0 -n $company.$project.WebAPI -o $company.$project.WebAPI
dotnet sln add $company.$project.WebAPI
mkdir $company.$project.WebAPI/Helpers
mkdir $company.$project.WebAPI/Commands
mkdir $company.$project.WebAPI/Queries
mkdir $company.$project.WebAPI/DataTransferObjects

dotnet new classlib -f net5.0 -n $company.$project.Application -o $company.$project.Application 
dotnet sln add $company.$project.Application
mkdir $company.$project.Application/Services

dotnet new classlib -f net5.0 -n $company.$project.Domain -o $company.$project.Domain 
dotnet sln add $company.$project.Domain
mkdir $company.$project.Domain/Enums
mkdir $company.$project.Domain/Models
mkdir $company.$project.Domain/Services

dotnet new classlib -f net5.0 -n $company.$project.Infrastructure -o $company.$project.Infrastructure 
dotnet sln add $company.$project.Infrastructure
mkdir $company.$project.Infrastructure/Database
mkdir $company.$project.Infrastructure/Database/Entities
mkdir $company.$project.Infrastructure/Database/Enums
mkdir $company.$project.Infrastructure/Database/Migrations
cd $company.$project.Infrastructure
dotnet add package Microsoft.EntityFrameworkCore.SqlServer -v 5.0.14
dotnet add package Microsoft.EntityFrameworkCore.Design -v 5.0.14
dotnet add package Microsoft.EntityFrameworkCore.Tools -v 5.0.14
cd ..

dotnet new classlib -f net5.0 -n $company.$project.Repository -o $company.$project.Repository 
dotnet sln add $company.$project.Repository
mkdir $company.$project.Repository/Helpers
mkdir $company.$project.Repository/Interfaces
mkdir $company.$project.Repository/Repositories

dotnet new xunit -f net5.0 -n $company.$project.Tests -o $company.$project.Tests 
dotnet sln add $company.$project.Tests
mkdir $company.$project.Tests/Integration
mkdir $company.$project.Tests/Unit

#Create Angular UI application
mkdir $company.$project.UI
cd $company.$project.UI
ng new angular --routing true --strict true --style css
cd angular
npm install primeng --save
npm install primeicons --save
awk 'NR==30{print "              \"./node_modules/primeicons/primeicons.css\","}1' angular.json > angular
rm angular.json
mv angular angular.json
awk 'NR==30{print "              \"./node_modules/primeng/resources/themes/bootstrap4-light-blue/theme.css\","}1' angular.json > angular
rm angular.json
mv angular angular.json
awk 'NR==30{print "              \"./node_modules/primeng/resources/primeng.min.css\","}1' angular.json > angular
rm angular.json
mv angular angular.json
--skip-tests
ng generate interceptor app --skip-tests true
cd src/app
mkdir data-transfer-objects
mkdir enums
mkdir library
mkdir models
mkdir pages
mkdir pages/private
mkdir pages/public
mkdir pipes
mkdir request-models
mkdir request-models/commands
mkdir request-models/queries
mkdir services
