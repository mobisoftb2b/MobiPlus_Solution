using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.Dashboard
{
    public class CustDailyTasks
    {
        public int? AgentId { get; set; }
        public string DriverName { get; set; }
        public string CustomerDesc { get; set; }
        public long? Shipment { get; set; }
        public string Address { get; set; }
        public string Status { get; set; }
        public string Orders { get; set; }
        public string TravelHours { get; set; }
        public string ServiceHours { get; set; }
        public string OriginalTime { get; set; }
        public string DeliveryTime { get; set; }
        public string Style_Orders { get; set; }
        public string NotVisited { get; set; }
        public string NotFullDelivery { get; set; }
        public string AgentReturn { get; set; }
        public string DriverReturn { get; set; }
        public string DriverStatus { get; set; }
        public string ImgStatus { get; set; }
        public string Mission { get; set; }
        public int? Progress { get; set; }
        public int? Cycle { get; set; }
        public string Visit { get; set; }
        public string Delivery { get; set; }
        public int? LongDistance { get; set; }
        public int? EndSupplyDate { get; set; }
        public long? CountryID { get; set; }
        public long? DistrID { get; set; }
        public string FromDate { get; set; }
        public string ActualSortOrder { get; set; }
        public int? CollectedSurfaces { get; set; }
        public string TaskDate { get; set; }
        public int? SortOrder { get; set; }
    }
}
