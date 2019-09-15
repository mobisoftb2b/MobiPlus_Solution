using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.Dashboard
{
    public class EndDayModel
    {
        public string ImgStatus { get; set; }
        public string DriverID { get; set; }
        public string DriverName { get; set; }
        public string Delivery { get; set; }
        public string FromDate { get; set; }
        public string AgentReturn { get; set; }
        public string DriverReturn { get; set; }
        public string Pallets { get; set; }
        public string DistansePlanned { get; set; }
        public string DistanseReal { get; set; }
        public string CountryID { get; set; }
        /// <summary>
        /// EndDayModel Details
        /// </summary>
        public string Shipment { get; set; }
        public string Driver { get; set; }
        public int? Order { get; set; }
        public string Customer { get; set; }
        public string CustomerAddress { get; set; }
        public string CutomerReturn { get; set; }
        public string CollectedSurfaces { get; set; }
        public string STYLE_CollectedSurfaces { get; set; }
        public string Status { get; set; }

    }
}
