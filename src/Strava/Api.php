<?php
namespace WMT\Strava;

class Api
{
    protected $client;
    protected $token;

    public function __construct()
    {
        $this->client = new \GuzzleHttp\Client(['base_url' => 'https://www.strava.com/api/v3/']);
        $this->token = 'fcd7c9c35565209c3a80337271419385aba0d655';
    }

    public function getAthlete()
    {
        return $this->sendRequest('athlete');
    }

    public function getActivityById($id)
    {
        return $this->sendRequest('activities/' . $id);
    }

    public function getAllActivities($page = 1)
    {
        return $this->sendRequest('athlete/activities?page=' . $page);
    }

    public function getActivitiesNewerThan($date)
    {
        $seconds = strtotime($date);
        return $this->sendRequest('athlete/activities?after=' . $seconds);
    }

    protected function sendRequest($query)
    {
        try {
            $response = $this->client->get($query, ['query' => ['access_token' => $this->token]]);
            return $response->json();
        } catch (RequestException $e) {
            echo $e->getRequest();
            if ($e->hasResponse()) {
                echo $e->getResponse();
            }
        }
    }
}
