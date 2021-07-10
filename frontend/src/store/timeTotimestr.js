export default {
  setTime(fmt) {
    const time = new Date(fmt * 1000);
    const Y = time.getFullYear();
    const M = (time.getMonth() + 1).toString().padStart(2, "0");
    const D = time
      .getDate()
      .toString()
      .padStart(2, "0");
    const h = time
      .getHours()
      .toString()
      .padStart(2, "0");
    const m = time
      .getMinutes()
      .toString()
      .padStart(2, "0");
    const s = time
      .getSeconds()
      .toString()
      .padStart(2, "0");
    return `${Y}-${M}-${D} ${h}:${m}:${s}`;
  },
  getNowTime(now) {
    let year = now.getFullYear();
    let month =
      now.getMonth() + 1 < 10 ? "0" + (now.getMonth() + 1) : now.getMonth() + 1;
    let day = now.getDate() < 10 ? "0" + now.getDate() : now.getDate();
    let hour = now.getHours() < 10 ? "0" + now.getHours() : now.getHours();
    let min = now.getMinutes() < 10 ? "0" + now.getMinutes() : now.getMinutes();
    let seconds = now.getSeconds() < 10 ? "0" + now.getSeconds() : now.getSeconds();
    let now_date = year + "-" + month + "-" + day;
    let now_time = hour + ":" + min + ":" + seconds;
    return {
      now_date,
      now_time
    };
  }
};
