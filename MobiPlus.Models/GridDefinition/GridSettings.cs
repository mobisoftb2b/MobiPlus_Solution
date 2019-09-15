using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.GridDefinition
{
    public class GridSettings
    {
        public long? ReportColID { get; set; }
        public string ReportName { get; set; }
        public string ColName { get; set; }
        public string ColCaption { get; set; }
        public int ColOrder { get; set; }
        public double? ColWidth { get; set; }
        public string Alignment { get; set; }
        public int? ColMaxLength { get; set; }
        public GridStyle Style { get; set; }
        public int ColIsSummary { get; set; }
        public int FormatID { get; set; }
                      
    }
}
