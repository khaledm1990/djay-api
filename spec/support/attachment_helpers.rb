module AttachmentHelpers
  def attach_image(record, attachment_name:, filename: "art.png")
    record.send(attachment_name).attach(
      io: StringIO.new("fake image"),
      filename: filename,
      content_type: "image/png"
    )
  end

  def attach_audio(track, attachment_name:, filename: "audio.mp3")
    track.send(attachment_name).attach(
      io: StringIO.new("fake audio"),
      filename: filename,
      content_type: "audio/mpeg"
    )
  end
end
