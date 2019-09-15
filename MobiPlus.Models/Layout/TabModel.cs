using System.Collections.Generic;

namespace MobiPlus.Models.Layout
{
    public class TabModel
    {
        public long? TabID { get; set; }
        public string TabDescription { get; set; }
        public long? FormID { get; set; }
        public IEnumerable<LayoutModel> Layouts { get; set; }

    }
}
