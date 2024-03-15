package grails.docker

class PingController {

    static allowedMethods = [ping: 'GET']

    def index() {
        render(text: 'pong',
                status: 200,
                contentType: 'text/plain')
    }
}
