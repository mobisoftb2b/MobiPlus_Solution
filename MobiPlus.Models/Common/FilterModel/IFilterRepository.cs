using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.Common.FilterModel
{
   public interface IFilterRepository<TOutput, TInput> : IDisposable where TOutput : class
    {
        Task<IEnumerable<TOutput>> GetDataByID(TInput param);
    }
}
