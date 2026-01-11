using Microsoft.EntityFrameworkCore;
using Wedding.Application.Services;
using Wedding.Domain.Repositories;
using Wedding.Infrastructure.Data.Persistence;
using Wedding.Infrastructure.Repositories;
using Wedding.Infrastructure.Repositories.Repositories;
using FluentValidation;
using FluentValidation.AspNetCore;
using Wedding.Application.Validators;
using Wedding.Application.Mappings;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();

// Add FluentValidation
builder.Services.AddFluentValidationAutoValidation();
builder.Services.AddValidatorsFromAssemblyContaining<ConfirmationRequestValidator>();

// Add AutoMapper
builder.Services.AddAutoMapper(typeof(MappingProfile));

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Configure Database
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<WeddingDbContext>(options =>
    options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString),
        b => b.MigrationsAssembly("Wedding.Infrastructure.Data"))); // Migrations in Data project

// Register Services & Repositories
builder.Services.AddScoped<IFamilyRepository, FamilyRepository>();
builder.Services.AddScoped<IIntoleranceRepository, IntoleranceRepository>();
builder.Services.AddScoped<IFamilyService, FamilyService>();

// CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        builder =>
        {
            builder.AllowAnyOrigin()
                   .AllowAnyMethod()
                   .AllowAnyHeader();
        });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAll");

app.UseAuthorization();

app.MapControllers();

// Auto-migrate database on startup
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    try 
    {
        var context = services.GetRequiredService<WeddingDbContext>();
        // Simple retry policy for DB availability
        int retries = 10;
        while (retries > 0)
        {
            try
            {
                if (context.Database.CanConnect())
                {
                    // context.Database.Migrate(); // Disabled manually managed DB initialization
                    break;
                }
            }
            catch 
            {
                if (retries == 1) throw; // Throw (and crash) on last attempt
                Thread.Sleep(2000); // Wait 2 seconds
            }
            retries--;
        }
    }
    catch (Exception ex) 
    {
        var logger = services.GetRequiredService<ILogger<Program>>();
        logger.LogError(ex, "An error occurred while emigrating the database.");
    }
}

app.Run();
