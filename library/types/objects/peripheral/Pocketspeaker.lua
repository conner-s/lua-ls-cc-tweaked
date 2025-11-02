---@meta

------
---[Official Documentation](https://tweaked.cc/peripheral/pocketspeaker.html)
---@class ccTweaked.peripheral.Pocketspeaker
Pocketspeaker = {}

---* Attempt to stream some audio data to the speaker. *  * This accepts a list of audio samples as amplitudes between -128 and 127. These are stored in an internal buffer * and played back at 48kHz. If this buffer is full, this function will return {

---@param audio table The audio data to play.
---@param volume? any The volume to play this audio at.
---@return any If there was room to accept this audio data.
---@throws LuaException If the audio data is malformed.
---@since 1.100
------
---[Official Documentation](https://tweaked.cc/peripheral/pocketspeaker.html#v:playAudio)
function Pocketspeaker.playAudio(audio, volume) end

---* Plays a note block note through the speaker. *  * This takes the name of a note to play, as well as optionally the volume * and pitch to play the note at. *  * The pitch argument uses semitones as the unit. This directly maps to the * number of clicks on a note block. For reference, 0, 12, and 24 map to F#, * and 6 and 18 map to C. *  * A maximum of 8 notes can be played in a single tick. If this limit is hit, this function will return * {

---@param instrumentA string The instrument to use to play this note.
---@param volumeA? any The volume to play the note at, from 0.0 to 3.0. Defaults to 1.0.
---@param pitchA? any The pitch to play the note at in semitones, from 0 to 24. Defaults to 12.
---@return any Whether the note could be played as the limit was reached.
---@throws LuaException If the instrument doesn't exist.
------
---[Official Documentation](https://tweaked.cc/peripheral/pocketspeaker.html#v:playNote)
function Pocketspeaker.playNote(instrumentA, volumeA, pitchA) end

---* Plays a Minecraft sound through the speaker. *  * This takes the [name of a Minecraft sound](https://minecraft.wiki/w/Sounds.json), such as * {

---@param name string The name of the sound to play.
---@param volumeA? any The volume to play the sound at, from 0.0 to 3.0. Defaults to 1.0.
---@param pitchA? any The speed to play the sound at, from 0.5 to 2.0. Defaults to 1.0.
---@return any Whether the sound could be played.
---@throws LuaException If the sound name was invalid.
------
---[Official Documentation](https://tweaked.cc/peripheral/pocketspeaker.html#v:playSound)
function Pocketspeaker.playSound(name, volumeA, pitchA) end

---* Stop all audio being played by this speaker. *  * This clears any audio that {

---@since 1.100
------
---[Official Documentation](https://tweaked.cc/peripheral/pocketspeaker.html#v:stop)
function Pocketspeaker.stop() end
