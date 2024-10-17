#include <QApplication>
#include <QProcess>
#include <QTextEdit>
#include <QVBoxLayout>
#include <QWidget>
#include <QPushButton>

class MyWindow : public QWidget {
public:
    MyWindow() {
        QVBoxLayout *layout = new QVBoxLayout(this);
        textEdit = new QTextEdit(this);
        textEdit->setReadOnly(true);

        QPushButton *button = new QPushButton("Получить данные", this);
        layout->addWidget(button);
        layout->addWidget(textEdit);

        connect(button, &QPushButton::clicked, this, &MyWindow::runCommand);
    }

private:
    QTextEdit *textEdit;

    void runCommand() {
        QProcess proc;
        proc.start("/bin/bash", QStringList() << "-c" << "rpm -qa | grep -i thunar | awk 'NR==2'");
        proc.waitForFinished();

        QString result = proc.readAllStandardOutput().trimmed();
        textEdit->setText(result);
    }
};

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    MyWindow window;
    window.resize(400, 300);
    window.setWindowTitle("Результаты команды");
    window.show();

    return app.exec();
}
