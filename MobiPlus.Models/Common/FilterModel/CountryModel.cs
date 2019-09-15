using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.Common
{
   public class CountryModel
    {
        public int? CountryID { get; set; }
        public string CountryName { get; set; }
        public string LatLng { get; set; }
        public DistributionModel DistributionCenter { get; set; }
    }
}
