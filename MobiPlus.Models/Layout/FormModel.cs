using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.Layout
{
   public class FormModel
    {
        public long? FormID { get; set; }
        public long? ParentFormID { get; set; }
        public string FormName { get; set; }
        public string RoutePath { get; set; }
        public string CssIcon { get; set; }


    }
}
