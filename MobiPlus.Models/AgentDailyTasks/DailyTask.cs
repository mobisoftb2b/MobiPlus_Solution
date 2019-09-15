using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.AgentDailyTasks
{
    public class DailyTask
    {
        public string TaskID { get; set; }
        public Customer Customer { get; set; }
        public string TaskDate { get; set; }
        public Agents Agents { get; set; }
        public decimal Lat { get; set; }
        public decimal Lon { get; set; }
        public string TaskAddress { get; set; }
        public string City { get; set; }
        public string TaskDescription { get; set; }
        public Color ColorLine { get; set; }



    }
}
