using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.Extensions.Configuration;

namespace DsaDAL.Models
{
    public partial class DsaPrepTrackerDBContext : DbContext
    {
        public DsaPrepTrackerDBContext()
        {
        }

        public DsaPrepTrackerDBContext(DbContextOptions<DsaPrepTrackerDBContext> options)
            : base(options)
        {
        }

        public virtual DbSet<DsaProblem> DsaProblems { get; set; }
        public virtual DbSet<User> Users { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            var builder=new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json");
            var config=builder.Build();
            var connectionString=config.GetConnectionString("DsaPrepTrackerDBConnectionString");    
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer(connectionString);
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<DsaProblem>(entity =>
            {
                entity.HasIndex(e => e.Status, "IX_DsaProblems_Status");

                entity.HasIndex(e => e.Topic, "IX_DsaProblems_Topic");

                entity.HasIndex(e => e.UserId, "IX_DsaProblems_UserId");

                entity.Property(e => e.CreatedAt).HasDefaultValueSql("(sysdatetime())");

                entity.Property(e => e.ProblemLink).HasMaxLength(500);

                entity.Property(e => e.Title)
                    .IsRequired()
                    .HasMaxLength(200);

                entity.HasOne(d => d.User)
                    .WithMany(p => p.DsaProblems)
                    .HasForeignKey(d => d.UserId)
                    .HasConstraintName("FK_DsaProblems_Users");
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.HasIndex(e => e.Email, "UQ_Users_Email")
                    .IsUnique();

                entity.Property(e => e.Id).HasDefaultValueSql("(newid())");

                entity.Property(e => e.CreatedAt).HasDefaultValueSql("(sysdatetime())");

                entity.Property(e => e.Email)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.PasswordHash)
                    .IsRequired()
                    .HasMaxLength(255);
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
