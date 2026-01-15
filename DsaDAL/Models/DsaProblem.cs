using System;
using System.Collections.Generic;

namespace DsaDAL.Models
{
    public partial class DsaProblem
    {
        public int Id { get; set; }
        public Guid UserId { get; set; }
        public string Title { get; set; }
        public int Topic { get; set; }
        public int Difficulty { get; set; }
        public int Platform { get; set; }
        public int Status { get; set; }
        public string ProblemLink { get; set; }
        public string Notes { get; set; }
        public DateTime? SolvedDate { get; set; }
        public int RevisionCount { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
        public bool NeedRevision { get; set; }

        public virtual User User { get; set; }
    }
}
