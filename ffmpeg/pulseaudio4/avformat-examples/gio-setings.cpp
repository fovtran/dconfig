// g++ program.cc -o program `pkg-config --cflags --libs glibmm-2.4 giomm-2.4`
// https://stackoverflow.com/questions/28582082/reading-gsettings-from-c-program
// https://developer-old.gnome.org/glibmm/stable/classGio_1_1Settings.html
// https://developer-old.gnome.org/glibmm/stable/
// https://gitlab.gnome.org/GNOME/gsettings-desktop-schemas

#include <giomm/settings.h>
#include <iostream>

int main() {
  Glib::RefPtr<Gio::Settings> s = Gio::Settings::create("com.ubuntu.user-interface");
  s->set_int("scale-factor", 12);
  int i = s->get_int("scale-factor");

  std::cout << i << std::endl;
}
