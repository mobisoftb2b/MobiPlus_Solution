using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Text;

namespace MobiPlusTools
{
    
    public class ReflectionPopulator<T>
    {
        public virtual List<T> CreateList(SqlDataReader reader)
        {
            var results = new List<T>();
            Func<SqlDataReader, T> readRow = this.GetReader(reader);

            while (reader.Read())
                results.Add(readRow(reader));

            return results;
        }
            
        private Func<SqlDataReader, T> GetReader(SqlDataReader reader)
        {
            List<string> readerColumns = new List<string>();
            for (int index = 0; index < reader.FieldCount; index++)
                readerColumns.Add(reader.GetName(index));

            var readerParam = Expression.Parameter(typeof(SqlDataReader), "reader");
            var readerGetValue = typeof(SqlDataReader).GetMethod("GetValue");

            var dbNullValue = typeof(System.DBNull).GetField("Value");
            var dbNullExp = Expression.Field(Expression.Parameter(typeof(System.DBNull), "System.DBNull"), dbNullValue);

            List<MemberBinding> memberBindings = new List<MemberBinding>();
            foreach (var prop in typeof(T).GetProperties())
            {
                object defaultValue = null;
                if (prop.PropertyType.IsValueType)
                    defaultValue = Activator.CreateInstance(prop.PropertyType);
                else if (prop.PropertyType.Name.ToLower().Equals("string"))
                    defaultValue = string.Empty;

                if (readerColumns.Contains(prop.Name))
                {
                    var indexExpression = Expression.Constant(reader.GetOrdinal(prop.Name));
                    var getValueExp = Expression.Call(readerParam, readerGetValue, new Expression[] { indexExpression });

                    var testExp = Expression.NotEqual(dbNullExp, getValueExp);
                    var ifTrue = Expression.Convert(getValueExp, prop.PropertyType);
                    var ifFalse = Expression.Convert(Expression.Constant(defaultValue), prop.PropertyType);

                    MemberInfo mi = typeof(T).GetMember(prop.Name)[0];
                    MemberBinding mb = Expression.Bind(mi, Expression.Condition(testExp, ifTrue, ifFalse));
                    memberBindings.Add(mb);
                }
            }

            var newItem = Expression.New(typeof(T));
            var memberInit = Expression.MemberInit(newItem, memberBindings);


            var lambda = Expression.Lambda<Func<SqlDataReader, T>>(memberInit, new ParameterExpression[] { readerParam });
            Delegate resDelegate = lambda.Compile();

            return (Func<SqlDataReader, T>)resDelegate;
        }

    }
}
