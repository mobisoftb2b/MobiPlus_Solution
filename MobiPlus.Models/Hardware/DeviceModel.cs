using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MobiPlus.Models.Hardware
{
    public class DeviceModel
    {
        public int? ID { get; set; }
        public string DeviceID { get; set; }
        public int? DeviceTypeID { get; set; }
        public string DeviceTypeName { get; set; }
        public int? Status { get; set; }
        public string StatusName { get; set; }
        public string Comment { get; set; }
        public bool isBusy { get; set; }
        public int CountryID { get; set; }

    }
}