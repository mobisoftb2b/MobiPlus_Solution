#region Using directives

using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.Caching;

#endregion

namespace CacheHandler
{
    public  class CacheObj
    {
        private  ObjectCache cache= MemoryCache.Default;
        private  CacheItemPolicy policy=new CacheItemPolicy();

        //public CacheObj()
        //{
        //    cache = MemoryCache.Default;
        //    policy = new CacheItemPolicy();
        //}
        public  void Add(string Key, Object Value)
        {
            cache.Add(Key, Value, policy);
        }
        public  void Update(string Key, Object Value)
        {
            cache.Set(Key, Value, policy);
        }
        public  void Remove(string Key)
        {
            cache.Remove(Key);
        }
        public  object Get(string Key)
        {
            return cache[Key];
        }
    }
}
