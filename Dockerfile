# --- Etapa 1: Build (Compilación) ---
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiamos archivos de proyecto primero para aprovechar el cache de Docker
# Usamos un comodín para capturar el csproj sin importar el nombre exacto
COPY *.sln .
COPY *.csproj ./ 
RUN dotnet restore

# Ahora copiamos todo el código
COPY . .

# Publicamos la aplicación
# Usamos el nombre que me pasaste: comara.csproj
RUN dotnet publish "comara.csproj" -c Release -o /app/publish /p:UseAppHost=false

# --- Etapa 2: Runtime (Ejecución) ---
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# .NET 8 escucha en el 8080 por defecto, pero esto lo asegura
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "comara.dll"]