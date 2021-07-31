const Sequelize = require('sequelize');
module.exports = function(sequelize, DataTypes) {
  return sequelize.define('jingwei', {
    sid: {
      autoIncrement: true,
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    LngLat: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    BM: {
      type: DataTypes.STRING(255),
      allowNull: true,
      unique: "1"
    },
    address: {
      type: DataTypes.STRING(255),
      allowNull: true
    }
  }, {
    sequelize,
    tableName: 'jingwei',
    timestamps: false,
    indexes: [
      {
        name: "1",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "BM" },
        ]
      },
      {
        name: "PRIMARY",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "sid" },
        ]
      },
    ]
  });
};
