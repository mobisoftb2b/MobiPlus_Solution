using MobiPlus.Models.Dashboard;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.AgentDailyTasks
{
    public class Customer
    {
        public string CustomerID { get; set; }
        public string CustomerName { get; set; }
        public bool IsVisit { get; set; }
        public string AgentId { get; set; }
        public string Address { get; set; }
        public DateTime? LastChange { get; set; }
        public string Lat { get; set; }
        public string Lon { get; set; }
        public int IsNotSupplayAndVisit { get; set; }
        public GPSLocation Location { get; set; }
        public string Color { get; set; }
    }
}
