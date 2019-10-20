using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace NMS.Core
{
    public class AnnualRequirementMst
    {
        public int Id { get; set; }
        public int ImporterId { get; set; }
        public DateTime SubmissionDate { get; set; }
        [ForeignKey("AnnReqMstId")]
        public virtual IEnumerable<AnnualRequirementDtl> AnnualRequirementDtls { get; set; }
    }
}
