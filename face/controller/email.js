const HomeService = require('../service/code')
const { Sequelize } = require('sequelize');
const sequelize = new Sequelize('apitest', 'apitest', 'apitest', {
host: '127.0.0.1',
dialect: 'mysql'/* 选择 'mysql' | 'mariadb' | 'postgres' | 'mssql' 其一 */
})

const db = require('../tool/db')
const path = require('path')
const fs = require('fs'); // 载入fs模块
var COS = require('cos-nodejs-sdk-v5');
var cos = new COS({
   SecretId: 'AKIDlKgohNp21kETTDiyznPp7B3h6HEwPdcN',
   SecretKey: 'Y05wXu2vZ7QUJtDJAmBMK5e1YxAB4mIa'
});

module.exports = {
  getCode: async(ctx, next) => {
    let {
      userMail,uName,uPhone,vMode,vType
    } = ctx.request.body
    
    try{
      let index = await HomeService.getCode(userMail,uName,uPhone,vMode,vType)
      ctx.response.body = index
    }catch(e){
      ctx.response.body = {errorMsg:e}
    }
  },
  checkCode: async(ctx, next) => {
    let {
      userMail,
      userCode
    } = ctx.request.body

    try{
      let index = await HomeService.checkCode(userMail,userCode)
      ctx.response.body = index
    }catch(e){
      ctx.response.body = {errorMsg:e}
    }
  },
  clock: async(ctx, next) => {
    // let no =`${Date.now()}`+'.jpg'

    let {
      site,
      date,
      time,
      id,
      name,
      bm
    } = ctx.request.body

    try{
      const { QueryTypes } = require('sequelize')
      const userList = await sequelize.query(`select QJ,QJdate1,QJdate2 from face where ID = '${id}'`, { type: QueryTypes.SELECT })
      let index = await db.Kaoqin.create({ BM : bm , ID: id , date : date , time: time , name : name , nbr: site })
      ctx.response.body = userList
    }catch(e){
      ctx.response.body = {errorMsg:e}
    }

    // // 上传单个文件
    // let file = ctx.request.files.file; // 获取上传文件
    
  //   let re = await new Promise ((resolve) =>{cos.putObject({
  //     Bucket: 'ls-1257243133', /* 必须 */
  //     Region: 'ap-guangzhou',    /* 必须 */
  //     Key: no,              /* 必须 */
  //     StorageClass: 'STANDARD',
  //     Body: fs.createReadStream(file.path), // 上传文件对象
  //     onProgress: function(progressData) {
  //       console.log(JSON.stringify(progressData));
  //     }
  //  },function(err, data) {
  //     let index = HomeService.checkClock(site,data['Location'],date,time)
  //     db.Kaoqin.create({ device: '手机' , ID: id , date : dt , time: tm , name : nm , nbr: site })
  //     console.log(data['Location'])
  //     return resolve(index)
  //  })
  // })
  },
  //人脸库
  upface: async(ctx, next) => {

    let {
      id,
      nm,
      set,
      url
    } = ctx.request.body
    // 上传单个文件

    let dt = String(nm).split(',')

  if (url=='file'){
      
    let file = ctx.request.files.file;
    let Id = id + '.jpg'
    
    await cos.putObject({
    Bucket: 'zngjng-1257243133', /* 必须 */
    Region: 'ap-guangzhou',    /* 必须 */
    Key: Id ,              /* 必须 */
    StorageClass: 'STANDARD',
    Body: fs.createReadStream(file.path), // 上传文件对象
    onProgress: function(progressData) {
      console.log(JSON.stringify(progressData));
    }
    }, function(err, data) {

    db.Face.upsert({ faceid: data['Location'] , ID: id ,name: dt[0] , Set: set, BM: dt[1]}, {updateOnDuplicate:true});

    if (set == 0){
    // Depends on tencentcloud-sdk-nodejs version 4.0.3 or higher
    const tencentcloud = require("tencentcloud-sdk-nodejs");

    const IaiClient = tencentcloud.iai.v20200303.Client;

    const clientConfig = {
      credential: {
        secretId: "AKIDlKgohNp21kETTDiyznPp7B3h6HEwPdcN",
        secretKey: "Y05wXu2vZ7QUJtDJAmBMK5e1YxAB4mIa",
      },
      region: "ap-guangzhou",
      profile: {
        httpProfile: {
          endpoint: "iai.tencentcloudapi.com",
        },
      },
    };

    const client = new IaiClient(clientConfig);
    const params = {
        "GroupId": "1",
        "PersonName": nm,
        "PersonId": id,
        "Url": 'http://' +data['Location']
    };
    client.CreatePerson(params).then(
      (data) => {
        console.log(data)
      },
      (err) => {
        console.error("error", err);
      }
    )
   }
   })
  }else{

    db.Face.upsert({ faceid: url , ID: id ,name: dt[0] , Set: set, BM: dt[1]}, {updateOnDuplicate:true});

    if (set == 0){
      // Depends on tencentcloud-sdk-nodejs version 4.0.3 or higher
      const tencentcloud = require("tencentcloud-sdk-nodejs");
    
      const IaiClient = tencentcloud.iai.v20200303.Client;
    
      const clientConfig = {
        credential: {
          secretId: "AKIDlKgohNp21kETTDiyznPp7B3h6HEwPdcN",
          secretKey: "Y05wXu2vZ7QUJtDJAmBMK5e1YxAB4mIa",
        },
        region: "ap-guangzhou",
        profile: {
          httpProfile: {
            endpoint: "iai.tencentcloudapi.com",
          },
        },
      };
    
      const client = new IaiClient(clientConfig);
      const params = {
          "GroupId": "1",
          "PersonName": nm,
          "PersonId": id,
          "Url": 'http://' + url
      };
      client.CreatePerson(params).then(
        (data) => {
          console.log(data)
        },
        (err) => {
          console.error("error", err);
        }
      )
    }
  }
    ctx.response.body = {ret:0}
  },
  getface: async(ctx, next) => {
    let {
      currentPage
    } = ctx.request.body

    let offset = (currentPage - 1) * 20;
    let userList = await db.Face.findAndCountAll({
        //offet去掉前多少个数据
        offset,
        //limit每页数据数量
        limit: 20
    }).then(res => {
        let result = {};
        result.data = res.rows;
        result.total = res.count;
        return result;
    });

    ctx.response.body = userList
  },
  delface: async(ctx, next) => {
    let {
      id
    } = ctx.request.body

    let userList = await db.Face.destroy({
      where: {
        ID:id
      }
    })

        // Depends on tencentcloud-sdk-nodejs version 4.0.3 or higher
    const tencentcloud = require("tencentcloud-sdk-nodejs");

    const IaiClient = tencentcloud.iai.v20200303.Client;

    const clientConfig = {
      credential: {
        secretId: "AKIDlKgohNp21kETTDiyznPp7B3h6HEwPdcN",
        secretKey: "Y05wXu2vZ7QUJtDJAmBMK5e1YxAB4mIa",
      },
      region: "ap-guangzhou",
      profile: {
        httpProfile: {
          endpoint: "iai.tencentcloudapi.com",
        },
      },
    };

    const client = new IaiClient(clientConfig);
    const params = {
        "PersonId": id,
        "GroupId": "1"
    };
    client.DeletePersonFromGroup(params).then(
      (data) => {
        console.log(data);
      },
      (err) => {
        console.error("error", err);
      }
    );

    ctx.response.body = {
      delcount:userList,
      ret:0
    }
  },
  getkaoqin: async(ctx, next) => {
    let {
      currentPage
    } = ctx.request.body

    let offset = (currentPage - 1) * 20;
    let userList = await db.Kaoqin.findAndCountAll({
        //offet去掉前多少个数据
        offset,
        //limit每页数据数量
        limit: 20
    }).then(res => {
        let result = {};
        result.data = res.rows;
        result.total = res.count;
        return result;
    });

    ctx.response.body = userList
  },
  datekaoqin: async(ctx, next) => {
    let {
      nowdate,
      nextdate
    } = ctx.request.body

    const { QueryTypes } = require('sequelize');
    const userList = await sequelize.query(`select ID,device,name,nbr,date,time FROM kaoqin where date between  '${nowdate}'  and '${nextdate}'`, { type: QueryTypes.SELECT })

    ctx.response.body = userList
  },
  BMlist: async(ctx, next) => {
    // let {
    //   nowdate,
    //   nextdate,
    //   time1,
    //   time2
    // } = ctx.request.body

    const { QueryTypes } = require('sequelize')
    const userList = await sequelize.query(`select * from guize`, { type: QueryTypes.SELECT })
    // const userList = await sequelize.query(`select * from (select ID,device,name,nbr,date,time FROM kaoqin where date between '${nowdate}'  and '${nextdate}') temp where temp.time between '${time1}' and '${time2}'`, { type: QueryTypes.SELECT })

    ctx.response.body = userList
  },
  guize: async(ctx, next) => {
    let {
      bm,
      cont
    } = ctx.request.body
    const userList = await db.Guize.upsert({ BM:bm,content:cont }, {updateOnDuplicate:true});
    ctx.response.body = {ret:0,msg:userList}
  },
  getuser: async(ctx, next) => {
    let userList = await db.Face.findAndCountAll({
    }).then(res => {
        let result = {};
        result.data = res.rows;
        result.total = res.count;
        return result;
    });

    ctx.response.body = userList
  },
  getList: async(ctx, next) => {
    let {
      bm
    } = ctx.request.body

    const { QueryTypes } = require('sequelize')
    const GZ = await sequelize.query(`select content FROM guize where BM = '${bm}'`, { type: QueryTypes.SELECT })
    const GZ_json = JSON.parse(GZ[0]['content'])
    ctx.response.body = GZ_json
  },
  timekaoqin: async(ctx, next) => {
    let {
      nowdate,
      nextdate,
      time1,
      time2,
      bm
    } = ctx.request.body

    const { QueryTypes } = require('sequelize')
    const userList = await sequelize.query(`select * from (select * from (select ID,BM,name,nbr,date,time from kaoqin where date between '${nowdate}'  and '${nextdate}') temp where temp.time between '${time1}' and '${time2}') temp where temp.BM = '${bm}' `, { type: QueryTypes.SELECT })

    ctx.response.body = userList
  },
  delguize: async(ctx, next) => {
    let {
      bm
    } = ctx.request.body

    let userList = await db.Guize.destroy({
      where: {
        BM:bm
      }
    })
    ctx.response.body = userList
  },
  savejw: async(ctx, next) => {
    let {
      lnglat,
      bm,
      address
    } = ctx.request.body
    const userList = await db.Jingwei.upsert({ BM:bm,LngLat:lnglat,address:address }, {updateOnDuplicate:true});
    ctx.response.body = userList
  },
  getjw: async(ctx, next) => {
    let {
      bm
    } = ctx.request.body
    const userList = await db.Jingwei.findAll({
      where: {
        BM: bm
      }
    })
    ctx.response.body = userList
  },
  getalljw: async(ctx, next) => {
    const userList = await db.Jingwei.findAndCountAll({
      // //offet去掉前多少个数据
      // offset,
      // //limit每页数据数量
      // limit: 20
    }).then(res => {
        let result = {};
        result.data = res.rows;
        result.total = res.count;
        return result;
    });

    ctx.response.body = userList
  },
  deljw: async(ctx, next) => {
    let {
      bm
    } = ctx.request.body
    const userList = await db.Jingwei.destroy({
      where: {
        BM:bm
      }
    })
    ctx.response.body = userList
  }
}
