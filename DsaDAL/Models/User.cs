using System;
using System.Collections.Generic;

namespace DsaDAL.Models
{
    public partial class User
    {
        public User()
        {
            DsaProblems = new HashSet<DsaProblem>();
        }

        public Guid Id { get; set; }
        public string Email { get; set; }
        public string PasswordHash { get; set; }
        public DateTime CreatedAt { get; set; }

        public virtual ICollection<DsaProblem> DsaProblems { get; set; }
    }
}
