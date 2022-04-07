Config = {}

Config.RestrictedChannels = {
  [1] = {
    police = true,
    ambulance = true
  },
  [2] = {
    police = true,
    ambulance = true
  },
  [3] = {
    police = true,
    ambulance = true
  },
  [4] = {
    police = true
  },
  [5] = {
    ambulance = true
  }
}

Config.MaxFrequency = 500

Config.messages = {
  ['not_on_radio'] = 'You\'re not connected to a signal',
  ['on_radio'] = 'You\'re already connected to this signal',
  ['joined_to_radio'] = 'You\'re connected to: ',
  ['restricted_channel_error'] = 'You can not connect to this signal!',
  ['invalid_radio'] = 'This frequency is not available.',
  ['you_on_radio'] = 'You\'re already connected to this channel',
  ['you_leave'] = 'You left the channel.'
}
