---@meta

---* Disk drives are a peripheral which allow you to read and write to floppy disks and other "mountable media" (such as * computers or turtles). They also allow you to {@link #playAudio play records}. *  * When a disk drive attaches some mount (such as a floppy disk or computer), it attaches a folder called {@code disk}, * {@code disk2}, etc... to the root directory of the computer. This folder can be used to interact with the files on * that disk. *  * When a disk is inserted, a {@code disk} event is fired, with the side peripheral is on. Likewise, when the disk is * detached, a {@code disk_eject} event is fired. *  * ## Recipe *  *  *  * * @cc.module drive

------
---[Official Documentation](https://tweaked.cc/peripheral/drive.html)
---@class ccTweaked.peripheral.Drive
Drive = {}

---* Returns the ID of the disk inserted in the drive. * *

---@return any The ID of the disk in the drive, or {
---@since 1.4
------
---[Official Documentation](https://tweaked.cc/peripheral/drive.html#v:attach)
function Drive.attach() end

---* Ejects any disk that may be in the drive.

------
---[Official Documentation](https://tweaked.cc/peripheral/drive.html#v:ejectDisk)
function Drive.ejectDisk() end

---* Returns the title of the inserted audio disk. * *

---@return any The title of the audio, or {
------
---[Official Documentation](https://tweaked.cc/peripheral/drive.html#v:getAudioTitle)
function Drive.getAudioTitle() end

---* Returns the mount path for the inserted disk. * *

---@return any The mount path for the disk, or {
------
---[Official Documentation](https://tweaked.cc/peripheral/drive.html#v:getMountPath)
function Drive.getMountPath() end

---* Returns whether a disk with audio is inserted. * *

---@return any Whether a disk with audio is inserted.
------
---[Official Documentation](https://tweaked.cc/peripheral/drive.html#v:hasAudio)
function Drive.hasAudio() end

---* Returns whether a disk with data is inserted. * *

---@return any Whether a disk with data is inserted.
------
---[Official Documentation](https://tweaked.cc/peripheral/drive.html#v:hasData)
function Drive.hasData() end

---* Returns whether a disk is currently inserted in the drive. * *

---@return any Whether a disk is currently inserted in the drive.
------
---[Official Documentation](https://tweaked.cc/peripheral/drive.html#v:isDiskPresent)
function Drive.isDiskPresent() end

---* Plays the audio in the inserted disk, if available.

------
---[Official Documentation](https://tweaked.cc/peripheral/drive.html#v:playAudio)
function Drive.playAudio() end

---* Returns the label of the disk in the drive if available. * *

---@param label? any The label
---@return any The label of the disk, or {
------
---[Official Documentation](https://tweaked.cc/peripheral/drive.html#v:setDiskLabel)
function Drive.setDiskLabel(label) end

---* Stops any audio that may be playing. * *

------
---[Official Documentation](https://tweaked.cc/peripheral/drive.html#v:stopAudio)
function Drive.stopAudio() end
