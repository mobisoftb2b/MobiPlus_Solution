using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.Dashboard
{
    public class GPSLocation
    {
        public long? LocationID { get; set; }
        public string Lat { get; set; }
        public string Lng { get; set; }
        public string ReportGPS_LAT { get; set; }
        public string ReportGPS_Lng { get; set; }
        public string Comment { get; set; }

    }
}
