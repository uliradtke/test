import cv2
from pyzbar.pyzbar import decode
from kivy.clock import Clock
from kivy.graphics.texture import Texture
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.image import Image
from kivymd.app import MDApp
from kivymd.uix.label import MDLabel

class BarcodeScannerApp(MDApp):
    def build(self):
        layout = BoxLayout(orientation='vertical')
        
        # Kamera-Anzeige im Vollbild
        self.image = Image()
        layout.add_widget(self.image)
        
        # Textfeld unten für das Ergebnis
        self.label = MDLabel(
            text="Halte einen Barcode vor die Kamera",
            halign="center",
            font_style="H6",
            size_hint_y=0.2
        )
        layout.add_widget(self.label)
        
        # Auf Android greift 0 meistens auf die Hauptkamera zu
        self.capture = cv2.VideoCapture(0)
        
        # Kamera-Feed flüssig aktualisieren (30 FPS)
        Clock.schedule_interval(self.load_video, 1.0 / 30.0)
        
        return layout

    def load_video(self, *args):
        ret, frame = self.capture.read()
        
        if ret:
            # Barcodes im Live-Stream suchen
            detected_barcodes = decode(frame)
            
            for barcode in detected_barcodes:
                barcode_data = barcode.data.decode('utf-8')
                barcode_type = barcode.type
                # Gefundenen Code sofort im Label anzeigen
                self.label.text = f"Typ: {barcode_type}\nCode: {barcode_data}"
            
            # Bild für die Kivy-Oberfläche konvertieren
            buffer = cv2.flip(frame, 0).tobytes()
            texture = Texture.create(size=(frame.shape, frame.shape), colorfmt='bgr')
            texture.blit_buffer(buffer, colorfmt='bgr', bufferfmt='ubyte')
            self.image.texture = texture

    def on_stop(self):
        self.capture.release()

if __name__ == '__main__':
    BarcodeScannerApp().run()
