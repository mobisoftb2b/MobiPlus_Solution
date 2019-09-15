using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.AgentDailyTasks
{
    [Serializable]
    public class Agents
    {
        public long? AgentID { get; set; }
        public string Date { get; set; }
        public int? CountryID { get; set; }
        public string AgentName { get; set; }
        public DateTime? VisitDate { get; set; }
        public string ColorLine { get; set; }
        public SalesOrganization Organization { get; set; }

    }
}
