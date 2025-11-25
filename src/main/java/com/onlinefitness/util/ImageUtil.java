package com.onlinefitness.util;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

/**
 * Simple image helper to create thumbnails.
 */
public class ImageUtil {

    /**
     * Create a thumbnail for the given image file and save as target file.
     * Returns true on success.
     */
    public static boolean createThumbnail(File source, File target, int maxWidth, int maxHeight) throws IOException {
        BufferedImage srcImg = ImageIO.read(source);
        if (srcImg == null) throw new IOException("Unable to read image: " + source);
        int srcW = srcImg.getWidth();
        int srcH = srcImg.getHeight();

        double scale = Math.min((double) maxWidth / srcW, (double) maxHeight / srcH);
        if (scale > 1.0) scale = 1.0; // don't upscale

        int destW = Math.max(1, (int) Math.round(srcW * scale));
        int destH = Math.max(1, (int) Math.round(srcH * scale));

        BufferedImage dest = new BufferedImage(destW, destH, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2 = dest.createGraphics();
        g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        g2.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2.drawImage(srcImg, 0, 0, destW, destH, null);
        g2.dispose();

        String format = guessFormat(target.getName());
        return ImageIO.write(dest, format, target);
    }

    private static String guessFormat(String filename) {
        int idx = filename.lastIndexOf('.');
        if (idx >= 0) {
            String ext = filename.substring(idx + 1).toLowerCase();
            if (ext.equals("jpg") || ext.equals("jpeg")) return "jpg";
            if (ext.equals("png")) return "png";
            if (ext.equals("gif")) return "gif";
        }
        return "jpg";
    }
}
