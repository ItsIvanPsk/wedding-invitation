# See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
USER app
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["Wedding.API/Wedding.API.csproj", "Wedding.API/"]
COPY ["Wedding.Application/Wedding.Application.csproj", "Wedding.Application/"]
COPY ["Wedding.Domain/Wedding.Domain.csproj", "Wedding.Domain/"]
COPY ["Wedding.Infrastructure.Data/Wedding.Infrastructure.Data.csproj", "Wedding.Infrastructure.Data/"]
COPY ["Wedding.Infrastructure.Repositories/Wedding.Infrastructure.Repositories.csproj", "Wedding.Infrastructure.Repositories/"]
RUN dotnet restore "./Wedding.API/Wedding.API.csproj"
COPY . .
WORKDIR "/src/Wedding.API"
RUN dotnet build "./Wedding.API.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Wedding.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Wedding.API.dll"]
