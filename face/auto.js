const SequelizeAuto = require('sequelize-auto')
const auto = new SequelizeAuto(
    'apitest',     //数据库的库名
    'apitest',         //mysql数据库的用户名
    'apitest',     //mysql数据库的密码
    {
        host: '112.74.181.232',      // 数据库服务器ip
        dialect: 'mysql',
        directory: './models',  // prevents the program from writing to disk
        port: '3306',           // 数据库运行端口
        additional: {
            timestamps: false
        }
    }
)
auto.run(function (err) {
    if (err) throw err
    // console.log(auto.tables); // table list
    // console.log(auto.foreignKeys); // foreign key list

    //生成models表后，直接执行项目
    require('./bin/www')
});
