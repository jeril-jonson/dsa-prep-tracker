using DsaDAL.Models;
using DsaTrackerDAL;


using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Controllers
builder.Services.AddControllers();

// Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

//  Register DbContext (Scoped by default)
builder.Services.AddDbContext<DsaPrepTrackerDBContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("HealthCareDBConnectionString")
    )
);

// Register Repository as TRANSIENT
builder.Services.AddTransient<DsaTrackerRepository>();

var app = builder.Build();

// Pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();
