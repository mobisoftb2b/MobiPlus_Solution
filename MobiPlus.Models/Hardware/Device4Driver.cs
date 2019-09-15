using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MobiPlus.Models.Hardware
{
    public class Device4Driver
    {
        public int? ID { get; set; }
        public string DriverID { get; set; }
        public string DriverName { get; set; }
        public string DeviceID { get; set; }
        public int? DeviceTypeID { get; set; }
        public string DeviceTypeName { get; set; }
        public bool IsActive { get; set; }
        public string Comments { get; set; }
        public string CountryID { get; set; }
        public string DistrID { get; set; }
    }
}