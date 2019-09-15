using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MobiPlus.Models.LanguageTools
{
   public class ReportsTextSource
    {
       public long? ReportID { get; set; }
       public long? ReportColID { get; set; }
       public Language Languages { get; set; }
       public string KeyWord { get; set; }
       public string Url { get; set; }
       public string Text { get; set; }
       public DateTime? DateCreate { get; set; }
       public long? CreateBy { get; set; }
       public DateTime DateUpdate { get; set; }
       public long? UpdatedBy { get; set; }
    }
}
