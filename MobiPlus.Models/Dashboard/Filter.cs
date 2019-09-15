using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.Dashboard
{
    public abstract class Filter<T>  where T : class
    {
        public abstract void CreateFilter();
    }
}
