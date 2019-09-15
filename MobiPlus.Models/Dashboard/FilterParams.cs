using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CodeFirstStoredProcs;

namespace MobiPlus.Models.Dashboard
{
    public class FilterParams
    {
        public int? FormID { get; set; }
        public long? ReportID { get; set; }
        public int? TabID { get; set; }
        [StoredProcAttributes.Name("CountryID")]
        public long? CountryID { get; set; }
        [StoredProcAttributes.Name("DistrID")]
        public long? DistrID { get; set; }
        [StoredProcAttributes.Name("AgentID")]
        public long? AgentID { get; set; }
        public string AgentName { get; set; }
        [StoredProcAttributes.Name("FromDate")]
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string Shipment { get; set; }
        public int? Cycle { get; set; }
        public long? UserID { get; set; }
        public int? LanguageID { get; set; }
        public string CountryLanLng { get; set; }
        public int? VersionID { get; set; }
        public bool? IsUpdated { get; set; }
        public string CustomerID { get; set; }
        public string QuestionnaireID { get; set; }
    }
}
