module.exports = {

  daysToMinutes(days) { return days * 24 * 60; },


  getHumanTime(minutes) {
    let minute = Math.floor(minutes % 60);
    let hour = Math.floor(minutes / 60) % 24;
    let day = Math.floor(Math.floor(minutes / 60) / 24) + 1;

    let minuteString = `${minute}`;
    if (minute < 10) { minuteString = `0${minute}`; }
    return `Day ${day} - ${hour}:${minuteString}`;
  }
};
