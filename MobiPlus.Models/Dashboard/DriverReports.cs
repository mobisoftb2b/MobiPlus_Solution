using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.Dashboard
{
   public class DriverReports
    {
        public string DocStartTime { get; set; }
        public string DriverName { get; set; }
        public long? Reference { get; set; }
        public string Customer { get; set; }
        public long? ShipmentNumber { get; set; }
        public string Item { get; set; }
        public double? QTY { get; set; }
        public string ReasonDescription { get; set; }
    }

    public class DriverReportsNT
    {
        public string DriverName { get; set; }
        public long? ShipmentID { get; set; }
        public string Customer { get; set; }
        public string ReportDescription { get; set; }
        public string Delivery { get; set; }
    }
}
